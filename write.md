---
layout: default
title: 글쓰기
permalink: /write/
---
<section class="write-page">
  <div class="write-head">
    <div>
      <div class="eyebrow">POST EDITOR</div>
      <h1>개발 공부 기록 작성</h1>
      <p>작성한 내용을 Markdown 글로 바로 저장할 수 있습니다. 카테고리를 선택하면 생성되는 MD 파일의 Jekyll 카테고리에 그대로 반영됩니다.</p>
    </div>
    <div class="write-actions">
      <button type="button" id="save-draft">임시 저장</button>
      <button type="button" id="download-post" class="primary">Markdown 저장</button>
    </div>
  </div>

  <div class="editor-grid">
    <section class="editor-panel">
      <div class="editor-meta">
        <input id="post-title" type="text" placeholder="게시글 제목">
        <div class="editor-row">
          <input id="post-date" type="date">
          <div class="category-control">
            <select id="post-category" aria-label="게시글 카테고리">
              <option value="Java">Java</option>
              <option value="Java 기본">Java 기본</option>
              <option value="객체지향 / SOLID">객체지향 / SOLID</option>
              <option value="디자인 패턴">디자인 패턴</option>
              <option value="Generic">Generic</option>
              <option value="함수형 / Lambda / Stream">함수형 / Lambda / Stream</option>
              <option value="컬렉션">컬렉션</option>
              <option value="JVM">JVM</option>
              <option value="동시성">동시성</option>
              <option value="입출력 / NIO">입출력 / NIO</option>
              <option value="Spring">Spring</option>
              <option value="Spring Core / DI / AOP">Spring Core / DI / AOP</option>
              <option value="JPA / MyBatis">JPA / MyBatis</option>
              <option value="MVC / REST API">MVC / REST API</option>
              <option value="Security / JWT / OAuth2">Security / JWT / OAuth2</option>
              <option value="테스트 / 품질 관리">테스트 / 품질 관리</option>
              <option value="Spring AI">Spring AI</option>
              <option value="Database">Database</option>
              <option value="Oracle / SQL / PL-SQL">Oracle / SQL / PL-SQL</option>
              <option value="Redis">Redis</option>
              <option value="Backend">Backend</option>
              <option value="실시간 / 메시징">실시간 / 메시징</option>
              <option value="성능 / 부하 테스트">성능 / 부하 테스트</option>
              <option value="Frontend">Frontend</option>
              <option value="HTML / CSS / JavaScript">HTML / CSS / JavaScript</option>
              <option value="React">React</option>
              <option value="Infra">Infra</option>
              <option value="Linux">Linux</option>
              <option value="AWS / EC2">AWS / EC2</option>
              <option value="Docker">Docker</option>
              <option value="GitHub Actions / CI-CD">GitHub Actions / CI-CD</option>
              <option value="ML">ML</option>
              <option value="Machine Learning">Machine Learning</option>
              <option value="기타">기타</option>
            </select>
            <button type="button" id="add-category" class="category-add">+ 카테고리 추가</button>
          </div>
        </div>
        <div id="new-category-row" class="new-category-row" hidden>
          <input id="new-category" type="text" placeholder="새 카테고리 이름">
          <button type="button" id="confirm-category">추가</button>
          <button type="button" id="cancel-category">취소</button>
        </div>
        <input id="post-tags" type="text" placeholder="태그: Java, Spring, JPA">
        <div class="markdown-upload">
          <label for="markdown-file">기존 Markdown 파일 불러오기</label>
          <input id="markdown-file" type="file" accept=".md,.markdown,text/markdown">
          <small>기존 front matter와 제목·태그·본문을 읽어 홈페이지 카테고리로 자동 분류합니다.</small>
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

      <textarea id="post-body" spellcheck="false" placeholder="공부한 내용을 작성하세요.\n\n## 실행 흐름\n\n여기에 내용을 입력합니다.\n\n코드 블록도 버튼으로 넣을 수 있습니다."></textarea>
    </section>

    <section class="preview-panel">
      <div class="preview-label">PREVIEW</div>
      <article class="post-content" id="post-preview"></article>
    </section>
  </div>

  <div class="write-note">
    <strong>저장 방식</strong>
    <span>카테고리를 선택하거나 직접 추가한 뒤 <b>Markdown 저장</b>을 누르면 Jekyll용 게시글 파일이 생성됩니다. 다운로드한 파일을 <code>_posts</code>에 넣으면 해당 카테고리로 게시됩니다.</span>
  </div>
</section>

<script>
(() => {
  const title = document.getElementById('post-title');
  const date = document.getElementById('post-date');
  const category = document.getElementById('post-category');
  const tags = document.getElementById('post-tags');
  const body = document.getElementById('post-body');
  const markdownFile = document.getElementById('markdown-file');
  const preview = document.getElementById('post-preview');
  const addCategory = document.getElementById('add-category');
  const newCategoryRow = document.getElementById('new-category-row');
  const newCategory = document.getElementById('new-category');
  const confirmCategory = document.getElementById('confirm-category');
  const cancelCategory = document.getElementById('cancel-category');
  const draftKey = 'zuzusnasna-study-draft';
  const categoryKey = 'zuzusnasna-post-categories';

  const today = new Date();
  date.value = today.toISOString().slice(0, 10);

  function escapeHtml(value) {
    return value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;');
  }

  function renderMarkdown(source) {
    const lines = source.replace(/\r/g, '').split('\n');
    let html = '';
    let inCode = false;
    let code = [];
    let listOpen = false;

    const inline = text => escapeHtml(text)
      .replace(/`([^`]+)`/g, '<code>$1</code>')
      .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
      .replace(/<u>(.*?)<\/u>/g, '<u>$1</u>')
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

  function updatePreview() {
    preview.innerHTML = renderMarkdown(body.value);
    localStorage.setItem(draftKey, JSON.stringify({title: title.value, date: date.value, category: category.value, tags: tags.value, body: body.value}));
  }

  // 홈페이지 카테고리 ID와 글쓰기 선택지를 연결한다.
  const categoryMap = {
    'Java': ['Java', 'java-core'], 'Java 기본': ['Java', 'java-core'],
    '객체지향 / SOLID': ['Java', 'java-oop'], '디자인 패턴': ['Java', 'java-pattern'],
    'Generic': ['Java', 'java-generics'], '함수형 / Lambda / Stream': ['Java', 'java-functional'], '컬렉션': ['Java', 'java-collections'],
    'JVM': ['Java', 'java-jvm'], '동시성': ['Java', 'java-concurrency'], '입출력 / NIO': ['Java', 'java-io'],
    'Spring': ['Spring', 'spring-core'], 'Spring Core / DI / AOP': ['Spring', 'spring-core'],
    'JPA / MyBatis': ['Spring', 'spring-data'], 'MVC / REST API': ['Spring', 'spring-web'],
    'Security / JWT / OAuth2': ['Spring', 'spring-security'], '테스트 / 품질 관리': ['Spring', 'spring-testing'], 'Spring AI': ['Spring', 'spring-ai'],
    'Database': ['Database', 'database-oracle'], 'Oracle / SQL / PL-SQL': ['Database', 'database-oracle'],
    'Redis': ['Database', 'database-redis'], 'Backend': ['Backend', 'backend-performance'],
    '실시간 / 메시징': ['Backend', 'backend-messaging'], '성능 / 부하 테스트': ['Backend', 'backend-performance'],
    'Frontend': ['Frontend', 'frontend-html'], 'HTML / CSS / JavaScript': ['Frontend', 'frontend-html'],
    'React': ['Frontend', 'frontend-react'], 'Infra': ['Infra', 'infra-linux'], 'Linux': ['Infra', 'infra-linux'],
    'AWS / EC2': ['Infra', 'infra-aws'], 'Docker': ['Infra', 'infra-docker'],
    'GitHub Actions / CI-CD': ['Infra', 'infra-cicd'], 'ML': ['ML', 'ml'], 'Machine Learning': ['ML', 'ml']
  };

  const classifyRules = [
    ['spring-ai','Spring',/\b(spring ai|spring-ai|spring ai alibaba|spring ai model|chatclient|prompttemplate|ollama|openai api|embedding|vector store|retrieval augmented generation|\brag\b)\b|생성형.?ai|벡터.?스토어/i],
    ['java-jvm','Java',/\b(jvm|jit|gc|garbage collection|heap|metaspace|class loading|classloader)\b|가비지 컬렉션|클래스 로딩/i],
    ['java-collections','Java',/\b(collection|arraylist|linkedlist|hashmap|hashset|treeset|deque|iterator|comparator|list|set|map)\b|컬렉션/i],
    ['java-concurrency','Java',/\b(concurrency|synchronized|reentrantlock|executorservice|completablefuture|volatile|atomic|threadlocal|deadlock|thread|lock)\b|동시성|스레드/i],
    ['java-io','Java',/\b(filechannel|nio|inputstream|outputstream|bufferedreader|bufferedinputstream|serialization)\b|입출력|직렬화/i],
    ['java-pattern','Java',/\b(design pattern|singleton|strategy|factory|observer|command|decorator|adapter|facade|builder|prototype)\b|디자인.?패턴/i],
    ['java-oop','Java',/\b(solid|oop|inheritance|composition|coupling|cohesion|abstract class)\b|객체지향|상속|다형성|캡슐화|추상화/i],
    ['java-functional','Java',/\b(lambda|stream|functional programming)\b|람다|함수형/i],
    ['java-generics','Java',/\bgeneric\b|제네릭/i],
    ['spring-data','Spring',/\b(jpa|mybatis|hibernate|entitymanager|orm|fetch join)\b/i],
    ['spring-security','Spring',/\b(spring security|jwt|oauth2|oauth|csrf|cors|filter chain)\b/i],
    ['spring-testing','Spring',/\b(junit|mockito|mockmvc|integration test|test slice)\b|테스트|품질 관리/i],
    ['spring-web','Spring',/\b(rest api|spring mvc|controller|http status|pagination|idempotency)\b|웹.?mvc/i],
    ['spring-core','Spring',/\b(spring|di|ioc|aop|bean|applicationcontext|transaction|proxy)\b/i],
    ['database-redis','Database',/\b(redis|sorted set|zset|pub.?sub)\b/i],
    ['database-oracle','Database',/\b(oracle|sql|pl.?sql|cursor|procedure|trigger|job|query|index|execution plan|mysql|database)\b|데이터베이스|커서|프로시저|트리거/i],
    ['backend-messaging','Backend',/\b(websocket|stomp|kafka|rabbitmq|message broker|pub.?sub|outbox)\b|실시간.?메시징/i],
    ['backend-performance','Backend',/\b(k6|load test|stress test|performance|throughput|latency|benchmark)\b|부하.?테스트|성능/i],
    ['frontend-react','Frontend',/\b(react|jsx|vite|react router)\b/i],
    ['frontend-html','Frontend',/\b(html|css|javascript|typescript|dom|browser|frontend)\b|프론트엔드/i],
    ['infra-docker','Infra',/\b(docker|docker compose|container|image layer)\b/i],
    ['infra-aws','Infra',/\b(aws|ec2|s3|rds|vpc|iam|cloudwatch)\b/i],
    ['infra-cicd','Infra',/\b(github actions|ci.?cd|deployment pipeline|workflow)\b|배포 자동화/i],
    ['infra-linux','Infra',/\b(linux|ubuntu|nginx|systemd|shell|bash)\b/i],
    ['ml','ML',/\b(machine learning|scikit.?learn|pandas|numpy|classification|regression|decision tree|knn|svm)\b|머신러닝|기계학습/i]
  ];

  function classifyPost(text, currentCategory, currentSection) {
    const section = String(currentSection || '').trim().toLowerCase();
    const validSections = new Set(Object.values(categoryMap).map(item => item[1]));
    if (validSections.has(section)) {
      const mapped = Object.values(categoryMap).find(item => item[1] === section);
      return {category: mapped[0], section};
    }
    const normalized = String(currentCategory || '').trim().toLowerCase();
    const selected = Object.entries(categoryMap).find(([label]) => label.toLowerCase() === normalized);
    if (selected && !['java','spring','database','backend','frontend','infra','ml'].includes(normalized)) {
      return {category: selected[1][0], section: selected[1][1]};
    }
    const source = (text + ' ' + normalized).toLowerCase();
    for (const [id, parent, pattern] of classifyRules) {
      if (pattern.test(source)) return {category: parent, section: id};
    }
    const roots = {
      java:['Java','java-core'], spring:['Spring','spring-core'], database:['Database','database-oracle'],
      backend:['Backend','backend-performance'], frontend:['Frontend','frontend-html'],
      infra:['Infra','infra-linux'], ml:['ML','ml'], 'machine learning':['ML','ml']
    };
    const root = roots[normalized];
    return root ? {category: root[0], section: root[1]} : {category:'기타', section:''};
  }

  function parseMarkdownFile(markdown) {
    const match = markdown.match(/^---\s*\r?\n([\s\S]*?)\r?\n---\s*(?:\r?\n|$)/);
    if (!match) return {meta:{}, content:markdown};
    const meta = {};
    match[1].split(/\r?\n/).forEach(line => {
      const item = line.match(/^([\w-]+):\s*(.*)$/);
      if (!item) return;
      const value = item[2].trim();
      if (value.startsWith('[') && value.endsWith(']')) {
        meta[item[1]] = value.slice(1,-1).split(',').map(v => v.trim().replace(/^['"]|['"]$/g,''));
      } else {
        meta[item[1]] = value.replace(/^['"]|['"]$/g,'');
      }
    });
    return {meta, content:markdown.slice(match[0].length)};
  }

  markdownFile.addEventListener('change', () => {
    const file = markdownFile.files && markdownFile.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      const parsed = parseMarkdownFile(String(reader.result || ''));
      const meta = parsed.meta;
      const importedTitle = String(meta.title || file.name.replace(/\.(md|markdown)$/i,''));
      const importedTags = Array.isArray(meta.tags) ? meta.tags : (meta.tags ? [meta.tags] : []);
      const importedCategories = Array.isArray(meta.categories) ? meta.categories : (meta.categories ? [meta.categories] : []);
      const allText = [importedTitle, importedTags.join(' '), importedCategories.join(' '), parsed.content].join(' ');
      const inferred = classifyPost(allText, importedCategories[0] || '', meta.section || '');
      const inferredOption = Object.entries(categoryMap).find(([, value]) => value[0] === inferred.category && value[1] === inferred.section);
      title.value = importedTitle;
      const dateMatch = String(meta.date || '').match(/\d{4}-\d{2}-\d{2}/);
      if (dateMatch) date.value = dateMatch[0];
      const categoryLabel = inferredOption ? inferredOption[0] : inferred.category;
      if (!Array.from(category.options).some(option => option.value === categoryLabel)) addCategoryOption(categoryLabel, false);
      category.value = categoryLabel;
      tags.value = importedTags.join(', ');
      body.value = parsed.content.trim();
      updatePreview();
      alert('Markdown 파일을 불러왔습니다. 자동 분류: ' + inferred.category + ' / ' + inferred.section);
    };
    reader.onerror = () => alert('Markdown 파일을 읽지 못했습니다.');
    reader.readAsText(file, 'UTF-8');
  });

  function insertAround(before, after = before, placeholder = '내용') {
    const start = body.selectionStart;
    const end = body.selectionEnd;
    const selected = body.value.slice(start, end) || placeholder;
    body.setRangeText(before + selected + after, start, end, 'select');
    body.focus();
    updatePreview();
  }

  function addCategoryOption(name, selectIt = true) {
    const trimmed = name.trim();
    if (!trimmed) return false;
    const exists = Array.from(category.options).some(option => option.value.toLowerCase() === trimmed.toLowerCase());
    if (exists) {
      if (selectIt) category.value = trimmed;
      return false;
    }
    const option = document.createElement('option');
    option.value = trimmed;
    option.textContent = trimmed;
    category.appendChild(option);
    if (selectIt) category.value = trimmed;
    return true;
  }

  function loadCustomCategories() {
    try {
      const saved = JSON.parse(localStorage.getItem(categoryKey) || '[]');
      if (Array.isArray(saved)) saved.forEach(name => addCategoryOption(String(name), false));
    } catch (_) {}
  }

  function saveCustomCategories() {
    const builtIn = new Set([
      'Java', 'Java 기본', '객체지향 / SOLID', '디자인 패턴', 'Generic', '함수형 / Lambda / Stream', '컬렉션', 'JVM', '동시성', '입출력 / NIO',
      'Spring', 'Spring Core / DI / AOP', 'JPA / MyBatis', 'MVC / REST API', 'Security / JWT / OAuth2', '테스트 / 품질 관리', 'Spring AI',
      'Database', 'Oracle / SQL / PL-SQL', 'Redis', 'Backend', '실시간 / 메시징', '성능 / 부하 테스트',
      'Frontend', 'HTML / CSS / JavaScript', 'React', 'Infra', 'Linux', 'AWS / EC2', 'Docker', 'GitHub Actions / CI-CD',
      'ML', 'Machine Learning', '기타'
    ]);
    const custom = Array.from(category.options).map(option => option.value).filter(value => !builtIn.has(value));
    localStorage.setItem(categoryKey, JSON.stringify(custom));
  }

  addCategory.addEventListener('click', () => {
    newCategoryRow.hidden = false;
    newCategory.focus();
  });

  confirmCategory.addEventListener('click', () => {
    const name = newCategory.value.trim();
    if (!name) {
      newCategory.focus();
      return;
    }
    if (!addCategoryOption(name)) {
      alert('이미 있는 카테고리입니다.');
      newCategory.focus();
      newCategory.select();
      return;
    }
    saveCustomCategories();
    newCategory.value = '';
    newCategoryRow.hidden = true;
    updatePreview();
  });

  cancelCategory.addEventListener('click', () => {
    newCategory.value = '';
    newCategoryRow.hidden = true;
  });

  newCategory.addEventListener('keydown', event => {
    if (event.key === 'Enter') confirmCategory.click();
    if (event.key === 'Escape') cancelCategory.click();
  });

  document.querySelectorAll('.editor-toolbar button').forEach(button => button.addEventListener('click', () => {
    const action = button.dataset.action;
    if (action === 'bold') insertAround('**', '**', '강조할 내용');
    if (action === 'underline') insertAround('<u>', '</u>', '밑줄을 표시할 내용');
    if (action === 'heading') insertAround('## ', '', '제목');
    if (action === 'code') insertAround('```java\n', '\n```', 'System.out.println("hello");');
    if (action === 'quote') insertAround('> ', '', '인용 내용');
    if (action === 'list') insertAround('- ', '', '목록 내용');
    if (action === 'link') insertAround('[', '](https://example.com)', '링크 텍스트');
  }));

  [title, date, category, tags, body].forEach(input => input.addEventListener('input', updatePreview));
  category.addEventListener('change', updatePreview);

  document.getElementById('save-draft').addEventListener('click', () => {
    updatePreview();
    alert('현재 작성 내용이 이 브라우저에 임시 저장되었습니다.');
  });

  document.getElementById('download-post').addEventListener('click', () => {
    const postDate = date.value || new Date().toISOString().slice(0, 10);
    const safeTitle = (title.value || 'new-post').trim();
    const slug = safeTitle.toLowerCase().replace(/[^a-z0-9가-힣]+/g, '-').replace(/^-|-$/g, '') || 'new-post';
    const tagList = tags.value.split(',').map(tag => tag.trim()).filter(Boolean);
    const inferred = classifyPost([safeTitle, tagList.join(' '), body.value].join(' '), category.value, '');
    const selectedMap = categoryMap[category.value];
    const mapped = !selectedMap || selectedMap[0] === category.value
      ? [inferred.category, inferred.section]
      : selectedMap;
    const frontMatterLines = [
      '---',
      'layout: post',
      'title: "' + safeTitle.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"',
      'date: ' + postDate + ' 00:00:00 +0900',
      'categories: [' + mapped[0] + ']',
      mapped[1] ? 'section: ' + mapped[1] : null,
      'tags: [' + tagList.join(', ') + ']',
      '---'
    ].filter(line => line !== null);
    // Front Matter 종료 구분선 뒤에는 반드시 빈 줄을 둔다.
    // 빈 문자열을 filter(Boolean)으로 제거하면 본문 첫 줄과 ---가 붙을 수 있다.
    const frontMatter = frontMatterLines.join('\n') + '\n\n';
    const postBody = body.value.replace(/^\n+/, '');
    const markdown = frontMatter + postBody;
    // 저장 전에 Jekyll Front Matter 구조를 검사해 잘못된 파일 다운로드를 차단한다.
    if (!/^---\r?\n[\s\S]*?\r?\n---\r?\n\r?\n/.test(markdown)) {
      alert('게시글 형식이 올바르지 않습니다. 다시 저장해 주세요.');
      return;
    }
    const blob = new Blob([markdown], {type: 'text/markdown;charset=utf-8'});
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = postDate + '-' + slug + '.md';
    link.click();
    URL.revokeObjectURL(link.href);
  });

  loadCustomCategories();

  const saved = localStorage.getItem(draftKey);
  if (saved) {
    try {
      const draft = JSON.parse(saved);
      title.value = draft.title || '';
      date.value = draft.date || date.value;
      if (draft.category && !Array.from(category.options).some(option => option.value === draft.category)) addCategoryOption(draft.category, false);
      category.value = draft.category || 'Java';
      tags.value = draft.tags || '';
      body.value = draft.body || '';
    } catch (_) {}
  }
  updatePreview();
})();
</script>
