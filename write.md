---
layout: default
title: 글쓰기
permalink: /write/
---
<section class="write-page">
  <div class="write-head">
    <div class="write-head-copy">
      <div class="eyebrow">POST EDITOR</div>
      <h1>개발 공부 기록 작성</h1>
      <p>Markdown을 그대로 붙여넣으면 제목·날짜·태그를 자동으로 읽고 카테고리도 본문에서 자동 분류합니다.</p>
    </div>
    <div class="write-actions">
      <div class="write-action-buttons">
        <button type="button" id="save-draft">임시 저장</button>
        <button type="button" id="download-post" class="primary">Markdown 저장</button>
      </div>
      <p class="editor-help">저장된 파일은 <code>_posts</code> 폴더에 업로드하면 됩니다. 카테고리 입력은 더 이상 필요하지 않습니다.</p>
    </div>
  </div>

  <div class="editor-grid">
    <section class="editor-panel">
      <div class="editor-meta">
        <input id="post-title" type="text" placeholder="게시글 제목">
        <input id="post-date" type="date" aria-label="게시글 날짜">
        <input id="post-tags" type="text" placeholder="태그: Java, Spring, JPA">
        <div class="paste-guide">
          <strong>Markdown 그대로 붙여넣기</strong>
          <span>기존 .md 내용을 통째로 붙여넣어도 됩니다. Front Matter의 제목·날짜·태그를 자동으로 가져오고, 저장할 때 Front Matter는 본문에서 제거해 한 번만 생성합니다.</span>
        </div>
      </div>

      <div class="editor-toolbar" aria-label="서식 도구">
        <button type="button" data-action="bold"><strong>B</strong></button>
        <button type="button" data-action="underline"><u>U</u></button>
        <button type="button" data-action="heading">H2</button>
        <button type="button" data-action="code">{ }</button>
        <button type="button" data-action="quote">❝</button>
        <button type="button" data-action="list">• 목록</button>
        <button type="button" data-action="link">링크</button>
      </div>

      <textarea id="post-body" spellcheck="false" placeholder="Markdown 글 전체를 붙여넣거나 본문만 작성하세요.\n\n## 실행 흐름\n\n여기에 내용을 입력합니다."></textarea>
    </section>

    <section class="preview-panel">
      <div class="preview-label">PREVIEW</div>
      <article class="post-content" id="post-preview"></article>
    </section>
  </div>

  <div class="write-note">
    <strong>자동 처리</strong>
    <span>Spring AI, Java, Database, Backend, Frontend, Infra, ML 및 하위 메뉴를 제목·태그·본문의 기술 키워드로 자동 분류합니다.</span>
  </div>
</section>

<script>
(() => {
  const title = document.getElementById('post-title');
  const date = document.getElementById('post-date');
  const tags = document.getElementById('post-tags');
  const body = document.getElementById('post-body');
  const preview = document.getElementById('post-preview');
  const draftKey = 'zuzusnasna-study-draft';

  const now = new Date();
  const localToday = new Date(now.getTime() - now.getTimezoneOffset() * 60000);
  date.value = localToday.toISOString().slice(0, 10);

  function escapeHtml(value) {
    return String(value || '')
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/\"/g, '&quot;');
  }

  function parseYamlValue(value) {
    const text = String(value || '').trim();
    if (!text) return '';
    if (text.startsWith('[') && text.endsWith(']')) {
      return text.slice(1, -1).split(',').map(item => item.trim().replace(/^['\"]|['\"]$/g, '')).filter(Boolean);
    }
    return text.replace(/^['\"]|['\"]$/g, '');
  }

  function readFrontMatter(source) {
    const cleaned = String(source || '').replace(/^\uFEFF/, '').trimStart();
    const match = cleaned.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
    if (!match) return null;
    const data = {};
    match[1].split(/\r?\n/).forEach(line => {
      const separator = line.indexOf(':');
      if (separator < 0) return;
      data[line.slice(0, separator).trim()] = parseYamlValue(line.slice(separator + 1));
    });
    return { data, body: cleaned.slice(match[0].length).trimStart() };
  }

  function stripLeadingFrontMatter(source) {
    let cleaned = String(source || '').replace(/^\uFEFF/, '').trimStart();
    let previous = null;
    while (cleaned !== previous) {
      previous = cleaned;
      const match = cleaned.match(/^---\r?\n[\s\S]*?\r?\n---(?:\r?\n|$)/);
      if (!match) break;
      cleaned = cleaned.slice(match[0].length).trimStart();
    }
    return cleaned;
  }

  function normalizeDate(value) {
    const match = String(value || '').match(/(\d{4}-\d{2}-\d{2})/);
    return match ? match[1] : '';
  }

  function normalizeTags(value) {
    if (Array.isArray(value)) return value.join(', ');
    return String(value || '').replace(/^\[|\]$/g, '').split(',')
      .map(v => v.trim().replace(/^['\"]|['\"]$/g, '')).filter(Boolean).join(', ');
  }

  function importMarkdown(source) {
    const parsed = readFrontMatter(source);
    if (!parsed) {
      body.value = stripLeadingFrontMatter(source);
      updatePreview(false);
      return;
    }
    if (parsed.data.title) title.value = parsed.data.title;
    if (parsed.data.date) date.value = normalizeDate(parsed.data.date) || date.value;
    if (parsed.data.tags) tags.value = normalizeTags(parsed.data.tags);
    body.value = parsed.body;
    updatePreview(false);
  }

  function renderMarkdown(source) {
    const lines = stripLeadingFrontMatter(source).replace(/\r/g, '').split('\n');
    let html = '';
    let inCode = false;
    let code = [];
    let listOpen = false;

    const inline = text => escapeHtml(text)
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
      .replace(/__([^_]+)__/g, '<strong>$1</strong>')
      .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');

    const closeList = () => { if (listOpen) { html += '</ul>'; listOpen = false; } };

    lines.forEach(line => {
      if (line.trim().startsWith('```')) {
        if (inCode) {
          html += '<pre><code>' + escapeHtml(code.join('\n')) + '</code></pre>';
          code = [];
          inCode = false;
        } else {
          closeList();
          inCode = true;
        }
        return;
      }
      if (inCode) { code.push(line); return; }
      if (/^###\s+/.test(line)) { closeList(); html += '<h3>' + inline(line.replace(/^###\s+/, '')) + '</h3>'; return; }
      if (/^##\s+/.test(line)) { closeList(); html += '<h2>' + inline(line.replace(/^##\s+/, '')) + '</h2>'; return; }
      if (/^#\s+/.test(line)) { closeList(); html += '<h2>' + inline(line.replace(/^#\s+/, '')) + '</h2>'; return; }
      if (/^[-*]\s+/.test(line)) { if (!listOpen) { html += '<ul>'; listOpen = true; } html += '<li>' + inline(line.replace(/^[-*]\s+/, '')) + '</li>'; return; }
      closeList();
      if (/^>\s?/.test(line)) { html += '<blockquote>' + inline(line.replace(/^>\s?/, '')) + '</blockquote>'; return; }
      if (!line.trim()) return;
      html += '<p>' + inline(line) + '</p>';
    });

    closeList();
    if (inCode) html += '<pre><code>' + escapeHtml(code.join('\n')) + '</code></pre>';
    return html || '<p class="preview-empty">작성한 내용이 여기에 표시됩니다.</p>';
  }

  function updatePreview(save = true) {
    preview.innerHTML = renderMarkdown(body.value);
    if (save) localStorage.setItem(draftKey, JSON.stringify({ title: title.value, date: date.value, tags: tags.value, body: body.value }));
  }

  const classifyRules = [
    ['spring-ai', 'Spring', /\b(spring ai|spring-ai|chatclient|prompttemplate|ollama|openai api|embedding|vector store|retrieval augmented generation|model context protocol|mcp|rag|chat memory|chatmemory|chatmemoryrepository|messagechatmemoryadvisor)\b|생성형.?ai|벡터.?스토어|대화 기억/i],
    ['java-jvm', 'Java', /\b(jvm|jit|gc|garbage collection|heap|metaspace|class loading|classloader)\b|가비지 컬렉션|클래스 로딩/i],
    ['java-collections', 'Java', /\b(collection|arraylist|linkedlist|hashmap|hashset|treeset|deque|iterator|comparator)\b|컬렉션/i],
    ['java-concurrency', 'Java', /\b(concurrency|synchronized|reentrantlock|executorservice|completablefuture|volatile|atomic|threadlocal|deadlock|thread|lock)\b|동시성|스레드/i],
    ['java-io', 'Java', /\b(filechannel|nio|inputstream|outputstream|bufferedreader|bufferedinputstream|serialization)\b|입출력|직렬화/i],
    ['java-pattern', 'Java', /\b(design pattern|singleton|strategy|factory|observer|command|decorator|adapter|facade|builder|prototype)\b|디자인.?패턴/i],
    ['java-oop', 'Java', /\b(solid|oop|inheritance|composition|coupling|cohesion|abstract class)\b|객체지향|상속|다형성|캡슐화|추상화/i],
    ['java-functional', 'Java', /\b(lambda|stream|functional programming)\b|람다|함수형/i],
    ['java-generics', 'Java', /\bgeneric\b|제네릭/i],
    ['spring-data', 'Spring', /\b(jpa|mybatis|hibernate|entitymanager|orm|fetch join)\b/i],
    ['spring-security', 'Spring', /\b(spring security|jwt|oauth2|oauth|csrf|cors|filter chain)\b/i],
    ['spring-testing', 'Spring', /\b(junit|mockito|mockmvc|integration test|test slice)\b|테스트|품질 관리/i],
    ['spring-web', 'Spring', /\b(rest api|spring mvc|controller|http status|pagination|idempotency)\b|웹.?mvc/i],
    ['spring-core', 'Spring', /\b(spring|di|ioc|aop|bean|applicationcontext|transaction|proxy)\b/i],
    ['database-redis', 'Database', /\b(redis|sorted set|zset|pub.?sub)\b/i],
    ['database-oracle', 'Database', /\b(oracle|sql|pl.?sql|cursor|procedure|trigger|job|query|index|execution plan|mysql|database)\b|데이터베이스|쿼리|테이블/i],
    ['backend-messaging', 'Backend', /\b(websocket|stomp|kafka|rabbitmq|message broker|pub.?sub|outbox)\b|실시간.?메시징/i],
    ['backend-performance', 'Backend', /\b(k6|load test|performance|throughput|latency|p95|benchmark)\b|성능|부하 테스트/i],
    ['frontend-react', 'Frontend', /\b(react|vite|jsx|react router)\b/i],
    ['frontend-html', 'Frontend', /\b(html|css|javascript|js|dom)\b|프론트엔드/i],
    ['infra-cicd', 'Infra', /\b(github actions|ci\/cd|cicd|continuous integration|deployment pipeline)\b|배포 자동화/i],
    ['infra-docker', 'Infra', /\b(docker|container|docker compose)\b/i],
    ['infra-aws', 'Infra', /\b(aws|ec2|amazon web services)\b/i],
    ['infra-linux', 'Infra', /\b(linux|ubuntu|shell|bash)\b/i],
    ['ml', 'ML', /\b(machine learning|knn|logistic regression|decision tree|random forest|svc|scikit.?learn|classification)\b|머신러닝|분류 모델/i]
  ];

  function classifyPost() {
    const text = [title.value, tags.value, body.value].join(' ').replace(/\s+/g, ' ').trim();
    for (const [section, parent, rule] of classifyRules) {
      if (rule.test(text)) return [parent, section];
    }
    return ['', ''];
  }

  function yamlQuote(value) {
    return '"' + String(value || '').replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"';
  }

  function makeFrontMatter() {
    const [parent, section] = classifyPost();
    const tagList = tags.value.split(',').map(tag => tag.trim()).filter(Boolean);
    const safeParent = parent || 'Spring';
    const safeSection = section || 'spring-core';
    const lines = [
      '---',
      'layout: post',
      'title: ' + yamlQuote(title.value.trim()),
      'date: ' + date.value + ' 00:00:00 +0900',
      'categories: [' + yamlQuote(safeParent) + ']',
      'section: ' + safeSection,
      'tags: [' + tagList.map(yamlQuote).join(', ') + ']',
      '---',
      ''
    ];
    return { text: lines.join('\n'), parent: safeParent, section: safeSection };
  }

  function slugify(value) {
    return String(value || 'post').trim().toLowerCase()
      .replace(/[^a-z0-9가-힣]+/gi, '-')
      .replace(/^-+|-+$/g, '') || 'post';
  }

  document.querySelectorAll('.editor-toolbar button').forEach(button => {
    button.addEventListener('click', () => {
      const action = button.dataset.action;
      const start = body.selectionStart;
      const end = body.selectionEnd;
      const selected = body.value.slice(start, end);
      let replacement = selected;
      if (action === 'bold') replacement = '**' + (selected || '강조할 내용') + '**';
      if (action === 'underline') replacement = '<u>' + (selected || '밑줄 내용') + '</u>';
      if (action === 'heading') replacement = '## ' + (selected || '제목');
      if (action === 'code') replacement = '```java\n' + (selected || '코드') + '\n```';
      if (action === 'quote') replacement = '> ' + (selected || '인용 내용');
      if (action === 'list') replacement = (selected || '목록 항목').split('\n').map(line => '- ' + line.replace(/^[-*]\s+/, '')).join('\n');
      if (action === 'link') replacement = '[' + (selected || '링크') + '](https://)';
      body.setRangeText(replacement, start, end, 'end');
      body.focus();
      updatePreview();
    });
  });

  body.addEventListener('paste', event => {
    const pasted = event.clipboardData?.getData('text/plain') || '';
    if (!/^\s*---\r?\n/.test(pasted)) return;
    event.preventDefault();
    importMarkdown(pasted);
  });

  [title, date, tags, body].forEach(input => input.addEventListener('input', () => updatePreview()));

  document.getElementById('save-draft').addEventListener('click', () => {
    updatePreview();
    alert('현재 작성 내용을 브라우저에 임시 저장했습니다.');
  });

  document.getElementById('download-post').addEventListener('click', () => {
    title.value = title.value.trim();
    body.value = stripLeadingFrontMatter(body.value);
    if (!title.value) { alert('게시글 제목을 입력해 주세요.'); title.focus(); return; }
    if (!date.value) { alert('게시글 날짜를 입력해 주세요.'); date.focus(); return; }
    if (!body.value.trim()) { alert('게시글 본문을 입력해 주세요.'); body.focus(); return; }

    const frontMatter = makeFrontMatter();
    const markdown = frontMatter.text + body.value.trim() + '\n';
    const blob = new Blob([markdown], { type: 'text/markdown;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = date.value + '-' + slugify(title.value) + '.md';
    document.body.appendChild(anchor);
    anchor.click();
    anchor.remove();
    URL.revokeObjectURL(url);
    localStorage.removeItem(draftKey);
    alert('Markdown 파일을 저장했습니다. 자동 분류: ' + frontMatter.parent + ' / ' + frontMatter.section);
  });

  const saved = localStorage.getItem(draftKey);
  if (saved) {
    try {
      const data = JSON.parse(saved);
      if (data.title) title.value = data.title;
      if (data.date) date.value = data.date;
      if (data.tags) tags.value = data.tags;
      if (data.body) body.value = data.body;
    } catch (_) {}
  }

  updatePreview(false);
})();
</script>
